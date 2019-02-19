import sys
from PyQt5 import QtWidgets
from PyQt5.QtWidgets import QTableWidget, QTableWidgetItem, QComboBox
#from PyQt5.QtGui import QStandardItemModel, QStandardItem
from PyQt5.QtCore import *
from PyQt5 import QtCore
from PyQt5.QtGui import *
import design3
from dbfunctions import query1
from selectQueries import queryExams, queryGroups, queryDropped, queryEvilTeachers
from updateInsertQueries import defineLecturers_overview,\
     defineLecturers, defLectrComboGrps, defineExam, insertMarkPreview,\
     dropStudentsPreview, insertMarkCombo1,\
     insertMarkCombo2,insertMark, dropStudent

class myapp(QtWidgets.QMainWindow, design3.Ui_University):
    def __init__(self):
        super().__init__()
        self.setupUi(self)

        #history - exams
        self.HistExPushButton.clicked.connect(self.HistExPushButtonClicked)
        self.HistExTabledata = queryExams(2018);
        HistExHeader = ['type', 'year', 'month', 'day', 'discipline']
        HistExTablemodel = MyTableModel(self.HistExTabledata, HistExHeader, self)
        self.HistExTableView.setModel(HistExTablemodel)
        
        #history - groups
        self.HistGrPushButton.clicked.connect(self.HistGrPushButtonClicked)
        self.HistGrTabledata = queryGroups(2018);
        HistGrHeader = ['group ID', 'student ID', 'surname', 'first name', 'secnod name','status']
        HistGrTablemodel = MyTableModel(self.HistGrTabledata, HistGrHeader, self)
        self.HistGrpsTableView.setModel(HistGrTablemodel)

        #dropped students
        self.DrppdPushButton.clicked.connect(self.DrppdPushButtonClicked)
        self.DrppdTabledata = queryDropped(2018, self.DrppdComboBox.currentIndex()+1);
        DrppdHeader = ['group ID', 'student ID', 'surname', 'first name', 'secnod name','status']
        DrppdTablemodel = MyTableModel(self.DrppdTabledata, DrppdHeader, self)
        self.DrppdTableView.setModel(DrppdTablemodel)

        #evil teachers
        self.evilTRefresh()

        #make schedule (match teachers and disciplines) OR define exams
        self.mkSchedRefresh()
        
        #drop students
        self.dropStRefresh()
        
        #define exams, set marks
        self.DefExmPushButton.clicked.connect(self.defExmPushButtonClicked)
        n = 7;
        self.setMarksTable.setColumnCount(n)
        header1 = ['group', 'discipline', 'exam ID', 'data', 'teacher', 'student', 'mark']
        data1 = insertMarkPreview ();
        m = len(data1);
        self.setMarksTable.setRowCount(m+1)
        comboBoxData = insertMarkCombo1 ();
        comboBoxItems = [];
        for i in range (len(comboBoxData)):
            comboBoxItems.append(comboBoxData[i][1]);
        c1= QComboBox()
        c1.addItems(comboBoxItems);
        self.setMarksTable.setCellWidget(0, 2, c1);
        self.setMarksIDs = [-1, -1, -1]; #exm_id, student's id, mark value
        c1.activated.connect(self.defExmCombo1Chosen)
        
        for i in range(n):
            self.setMarksTable.setHorizontalHeaderLabels(header1)
            for j in range (m):
                item1 = data1[j][i];
                if type(item1) == int:
                    item1 = '{}'.format(item1);
                item1 = QTableWidgetItem(item1);
                self.setMarksTable.setItem(j+1, i, item1);

    def evilTRefresh(self):
        self.EvilTPushButton.clicked.connect(self.EvilTPushButtonClicked)
        self.EvilTabledata = queryEvilTeachers(2018, self.EvilTComboBox.currentIndex()+1, 1, 3);
        EvilTHeader = ['surname', 'first name', 'last name', 'marks count', 'mark value']
        EvilTablemodel = MyTableModel(self.EvilTabledata, EvilTHeader, self)
        self.EvilTableView.setModel(EvilTablemodel)
        self.evilTMark = 3
        self.EvilTMarkCombo.activated.connect(self.evilTMarkComboChanged)

    def evilTMarkComboChanged(self, index):
        self.evilTMark = index + 2

    def EvilTPushButtonClicked(self):
        text = self.EvilTLineEdit.text()
        minCount = self.EvilTCountLEdit.text()
        if len(text)<=4:
            if len(minCount) <= 4:
                self.EvilTabledata = queryEvilTeachers(int(text), self.EvilTComboBox.currentIndex()+1, int(minCount), self.evilTMark);
                EvilTHeader = ['surname', 'first name', 'last name', 'marks count', 'mark value']
                EvilTablemodel = MyTableModel(self.EvilTabledata, EvilTHeader, self)
                self.EvilTableView.setModel(EvilTablemodel)
                self.textBrowser.setHtml("<html>\
                <body style='background-color:Green; color:White;'>\
                Query successful</body></html>")
            else:
                self.textBrowser.setHtml("<html>\
                <body style='background-color:Tomato; color:White;'>\
                Type in minimal number</body></html>")
                    
        else:
            self.textBrowser.setHtml("<html>\
            <body style='background-color:Tomato; color:White;'>\
            Invalid year</body></html>")
            print('invalid year');

    def dropStRefresh(self):
        self.DropStTabledata = [];
        rows = dropStudentsPreview();
        for row in rows:
            self.DropStTabledata.append(row);
        DropStHeader = ['student\'s ID', 'surname', 'name', 'second name',\
        'status', 'exam ID', 'mark', 'exam type', 'exam date']
        DropStTablemodel = MyTableModel(self.DropStTabledata, DropStHeader, self)
        self.DropStTableView.setModel(DropStTablemodel)
        self.dropStStatuses = [];
        self.dropStIDs = [];
        for k in range(len(rows)):
            c = QComboBox()
            c.addItems(['g','s','d'])
            c.setProperty('row', k)
            i = self.DropStTableView.model().index(k,4)
            c.activated.connect(self.dropStComboChosen)
            self.DropStTableView.setIndexWidget(i,c)
            self.dropStStatuses.append(rows[k][4])
            self.dropStIDs.append(rows[k][0])
            if self.dropStStatuses[k] == 'd': 
                c.setCurrentIndex(2)
            elif self.dropStStatuses[k] == 's':
                c.setCurrentIndex(1)
        try: self.DropStPushButton.clicked.disconnect() 
        except Exception: pass
        self.DropStPushButton.clicked.connect(self.dropStButClicked)
                
    def dropStComboChosen(self, index):
        c = self.sender() #detecting from which column we are called
        row = c.property('row')
        print(row)
        print(index)
        statuses = ['g', 's', 'd']
        if self.dropStStatuses[row] == 'd':
            c.setCurrentIndex(2)
            self.textBrowser.setHtml("<html>\
            <body style='background-color:Tomato; color:White;'>\
            Admission of previously dismissed students is not supported</body></html>")
        else:
            self.dropStStatuses[row] = statuses[index]
        print(self.dropStStatuses)
    
    def dropStButClicked(self):
        text = "<html>\
            <body style='background-color:Green; color:White;'>\
            Query successful, dropped students: "
        for k in range(len(self.dropStIDs)):
            print('student:{}, status:{}'.format(self.dropStIDs[k], self.dropStStatuses[k]))
            if self.dropStStatuses[k] == 'd':
                print('dismissing student {}'.format(self.dropStIDs[k]))
                dropStudent(self.dropStIDs[k])
                text = '{}{},'.format(text, self.dropStIDs[k]);
        text = '{}</body></html>'.format(text);
        self.textBrowser.setHtml(text);

    def mkSchedRefresh(self):
        st = 'fill later'
        newRow = ['','','','',st,'','auto filled',st,st, 'auto filled'];
        self.mkSchedNewRowData = [-1,-1,-1,-1, -1];
        self.MkSchedTabledata = [];
        self.MkSchedTabledata.append(newRow);
        rows = defineLecturers_overview();
        for row in rows:
            self.MkSchedTabledata.append(row);
        MkSchedHeader = ['group ID', 'year', 'semester', 'teacher\'s ID',\
        'type of exam', 'discipline', 'exam ID', 'exam month', 'exam day', 'unique ID in table']
        MkSchedTablemodel = MyTableModel(self.MkSchedTabledata, MkSchedHeader, self)
        self.MkSchedTableView.setModel(MkSchedTablemodel)
        self.MkSchedComboBox.setCurrentIndex(0)
        try: self.MkSchedComboBox.activated.disconnect() 
        except Exception: pass
        self.MkSchedComboBox.activated.connect(self.mkSchedMod)
        self.MkSchedPushButton.setText("Append row")

        c0 = QComboBox()
        c0.addItems(['','1','2','3','4','5','6','7','8'])
        c0.activated.connect(self.mkSchedC0Clicked)
        i = self.MkSchedTableView.model().index(0,0)
        self.MkSchedTableView.setIndexWidget(i,c0)
        c1 = QComboBox()
        c1.addItems(['','2016','2017','2018','2019','2020','2021','2022'])
        c1.activated.connect(self.mkSchedC1Clicked)
        i = self.MkSchedTableView.model().index(0,1)
        self.MkSchedTableView.setIndexWidget(i,c1)
        c2 = QComboBox()
        c2.addItems(['','1','2','both'])
        c2.activated.connect(self.mkSchedC2Clicked)
        i = self.MkSchedTableView.model().index(0,2)
        self.MkSchedTableView.setIndexWidget(i,c2)
        c3 = QComboBox()
        c3.addItems(['','1','2','3','4','5','6','7','8', '9'])
        c3.activated.connect(self.mkSchedC3Clicked)
        i = self.MkSchedTableView.model().index(0,3)
        self.MkSchedTableView.setIndexWidget(i,c3)
        c4 = QComboBox()
        items = defLectrComboGrps()
        for i in range(len(items)):
            items[i] = items[i][0]
        print(items)
        c4.addItem('')
        c4.addItems(items)
        i = self.MkSchedTableView.model().index(0,5)
        self.MkSchedTableView.setIndexWidget(i,c4)
        c4.activated.connect(self.mkSchedC4Clicked)

        try: self.MkSchedPushButton.clicked.disconnect() 
        except Exception: pass
        self.MkSchedPushButton.clicked.connect(self.mkSchedButtonPushed)

    def mkSchedC0Clicked(self, index):
        if index > 0:
            self.mkSchedNewRowData[0] = index
            print(index)

    def mkSchedC1Clicked(self, index):
        if index > 0:
            self.mkSchedNewRowData[1] = index + 2015
            print(self.mkSchedNewRowData[1])

    def mkSchedC2Clicked(self, index):
        if index > 0:
            self.mkSchedNewRowData[2] = index
            print(self.mkSchedNewRowData[2])

    def mkSchedC3Clicked(self, index):
        if index > 0:
            self.mkSchedNewRowData[3] = index
            print(self.mkSchedNewRowData[3])
    def mkSchedC4Clicked(self, index):
        if index > 0:
            self.mkSchedNewRowData[4] = index
            print(self.mkSchedNewRowData[4])
            

    def mkSchedButtonPushed(self):
        if self.mkSchedNewRowData[0] == -1:
            self.textBrowser.setHtml("<html>\
                <body style='background-color:Tomato; color:White;'>\
                Choose group ID</body></html>")
        elif self.mkSchedNewRowData[1] == -1:
            self.textBrowser.setHtml("<html>\
                <body style='background-color:Tomato; color:White;'>\
                Choose a year</body></html>")
        elif self.mkSchedNewRowData[2] == -1:
            self.textBrowser.setHtml("<html>\
                <body style='background-color:Tomato; color:White;'>\
                Choose semester</body></html>")
        elif self.mkSchedNewRowData[3] == -1:
            self.textBrowser.setHtml("<html>\
                <body style='background-color:Tomato; color:White;'>\
                Choose a teacher</body></html>")
        elif self.mkSchedNewRowData[4] == -1:
            self.textBrowser.setHtml("<html>\
                <body style='background-color:Tomato; color:White;'>\
                Choose a discipline</body></html>")
        else:
            gr_id = self.mkSchedNewRowData[0]
            year = self.mkSchedNewRowData[1]
            semester = self.mkSchedNewRowData[2]
            t_id = self.mkSchedNewRowData[3]
            d_id = self.mkSchedNewRowData[4]
            defineLecturers(year, semester, d_id, t_id, gr_id)
            self.mkSchedRefresh()
            self.textBrowser.setHtml("<html>\
            <body style='background-color:Green; color:White;'>\
            Query successful</body></html>")
            
        

    def mkSchedMod(self, index):
        if index == 1:
            self.MkSchedPushButton.setText("Confirm changes")
            try: self.MkSchedPushButton.clicked.disconnect() 
            except Exception: pass
            self.MkSchedPushButton.clicked.connect(self.mkSchedMod2ButtCl)
            rows=[idx.row() for idx in self.MkSchedTableView.selectionModel().selectedRows()]
            self.newExams = []
            print(rows)
            k=0
            for r in rows:
                self.newExams.append([r,-1,-1,-1])
                c4 = QComboBox()
                c4.addItems(['','e','t','r'])
                c4.setProperty('no', k)
                c4.activated.connect(self.mkSchedC4mod2Activated)
                i = self.MkSchedTableView.model().index(r,4)
                self.MkSchedTableView.setIndexWidget(i,c4)
                c7 = QComboBox()
                c7.addItems(['','1','2','3','4','5','6','7','8','9','10','11','12'])
                c7.setProperty('no', k)
                c7.activated.connect(self.mkSchedC7mod2Activated)
                i = self.MkSchedTableView.model().index(r,7)
                self.MkSchedTableView.setIndexWidget(i,c7)
                days = ['']
                for idx in range (30):
                    days.append('{}'.format(idx+1))
                c8 = QComboBox()
                c8.addItems(days)
                c8.setProperty('no', k)
                c8.activated.connect(self.mkSchedC8mod2Activated)
                i = self.MkSchedTableView.model().index(r,8)
                self.MkSchedTableView.setIndexWidget(i,c8)
                k+=1
        else:
            self.mkSchedRefresh()

    def mkSchedMod2ButtCl(self):
        for i in range(len(self.newExams)):
            exm = self.newExams[i]
            row = exm[0]
            exm_type = exm[1]
            month = exm[2]
            day = exm[3]
            if exm[1] == -1:
                self.textBrowser.setHtml("<html>\
                <body style='background-color:Tomato; color:White;'>\
                Choose the type of an exam in all rows</body></html>")
            elif exm[2] == -1:
                self.textBrowser.setHtml("<html>\
                <body style='background-color:Tomato; color:White;'>\
                Choose a month in all rows</body></html>")
            elif exm[3] == -1:
                self.textBrowser.setHtml("<html>\
                <body style='background-color:Tomato; color:White;'>\
                Choose a day in all rows</body></html>")
            else:
                rowData = self.MkSchedTabledata[row]
                dtt_instance_id = rowData[9]
                defineExam(dtt_instance_id, day, month, exm_type)
                self.textBrowser.setHtml("<html>\
                <body style='background-color:Green; color:White;'>\
                Query successful</body></html>")
                print(rowData)
                
        print(self.newExams)

    def mkSchedC4mod2Activated(self, index):
        c4 = self.sender()
        examType = index
        self.newExams[c4.property('no')][1] = examType
        print('exam type:{}'.format(index))

    def mkSchedC7mod2Activated(self, index):
        c7 = self.sender()
        month = index
        self.newExams[c7.property('no')][2] = month
        print('exam month:{}'.format(index))

    def mkSchedC8mod2Activated(self, index):
        c8 = self.sender()
        day = index
        self.newExams[c8.property('no')][3] = day
        print('exam day:{}'.format(index))

    def defExmCombo1Chosen (self, index):
        comboBoxData = insertMarkCombo1 ();
        gr_id = comboBoxData[index][2];
        self.setMarksIDs[0] = comboBoxData[index][0];
        comboBoxData2 = insertMarkCombo2 (gr_id);
        self.comboBoxData2 = comboBoxData2;
        c2= QComboBox()
        combo2Items = [];
        for i in range (len(comboBoxData2)):
            combo2Items.append (comboBoxData2[i][1]);
        c2.addItems(combo2Items);
        self.setMarksTable.setCellWidget(0, 5, c2);
        c2.activated.connect(self.defExmCombo2Chosen)

    def defExmCombo2Chosen (self, index):
        self.setMarksIDs[1] = self.comboBoxData2[index][0];
        c3 = QComboBox ()
        c3.addItems(['2', '3', '4', '5'])
        self.setMarksTable.setCellWidget(0, 6, c3);
        c3.activated.connect(self.defExmCombo3Chosen)

    def defExmCombo3Chosen (self, index):
        self.setMarksIDs[2] = index + 2;
        print(self.setMarksIDs);

    def defExmPushButtonClicked(self):
        if self.setMarksIDs[0] == -1:
            self.textBrowser.setHtml("<html>\
            <body style='background-color:Tomato; color:White;'>\
            Choose exam</body></html>")
        elif self.setMarksIDs[1] == -1:
            self.textBrowser.setHtml("<html>\
            <body style='background-color:Tomato; color:White;'>\
            Choose student</body></html>")
        else:
            if self.setMarksIDs[2] == -1:
                self.setMarksIDs[2] = 2
            mark = self.setMarksIDs[2];
            stud_id = self.setMarksIDs[1];
            exm_id = self.setMarksIDs[0];
            db_ans = insertMark(mark, stud_id, exm_id)
            text = "<html>\
            <body style='background-color:Green; color:White;'>\
            Query successful, auxiliary information is: "
            text = '{}{}</body></html>'.format(text,db_ans);
            self.textBrowser.setHtml(text);

            data1 = insertMarkPreview ();
            n = 7;
            m = len(data1);
            self.setMarksTable.setRowCount(m+1)
            for i in range(n):
                for j in range (m):
                    item1 = data1[j][i];
                    if type(item1) == int:
                        item1 = '{}'.format(item1);
                    item1 = QTableWidgetItem(item1);
                    self.setMarksTable.setItem(j+1, i, item1);
            self.dropStRefresh()         
    
    def DrppdPushButtonClicked(self):
        text = self.DrppdLineEdit.text()
        if len(text)<=4:
            self.DrppdTabledata = queryDropped(int(text), self.DrppdComboBox.currentIndex()+1);
            DrppdHeader = ['group ID', 'student ID', 'surname', 'first name', 'secnod name','status']
            DrppdTablemodel = MyTableModel(self.DrppdTabledata, DrppdHeader, self)
            self.DrppdTableView.setModel(DrppdTablemodel)
            self.textBrowser.setHtml("<html>\
            <body style='background-color:Green; color:White;'>\
            Query successful</body></html>")
        else:
            self.textBrowser.setHtml("<html>\
            <body style='background-color:Tomato; color:White;'>\
            Invalid year</body></html>")
            print('invalid year');
    
    def HistExPushButtonClicked(self):
        text = self.HistExLineEdit.text()
        if len(text)<=4:
            self.HistExTabledata = queryExams(int(text));
            HistExHeader = ['type', 'year', 'month', 'day', 'discipline']
            HistExTablemodel = MyTableModel(self.HistExTabledata, HistExHeader, self)
            self.HistExTableView.setModel(HistExTablemodel)
            self.textBrowser.setHtml("<html>\
            <body style='background-color:Green; color:White;'>\
            Query successful</body></html>")
        else:
            self.textBrowser.setHtml("<html>\
            <body style='background-color:Tomato; color:White;'>\
            Invalid year</body></html>")
            print('invalid year');
    
    def HistGrPushButtonClicked(self):
        text2 = self.HistGrLineEdit.text()
        if len(text2)<=4:
            self.HistGrTabledata = queryGroups(int(text2));
            HistGrHeader = ['group ID', 'student ID', 'surname', 'first name', 'secnod name','status']
            HistGrTablemodel = MyTableModel(self.HistGrTabledata, HistGrHeader, self)
            self.HistGrpsTableView.setModel(HistGrTablemodel)
            self.textBrowser.setHtml("<html>\
            <body style='background-color:Green; color:White;'>\
            Query successful</body></html>")
        else:
            self.textBrowser.setHtml("<html>\
            <body style='background-color:Tomato; color:White;'>\
            Invalid year</body></html>")
            print('invalid year');
        

class MyTableModel(QAbstractTableModel):
    def __init__(self, datain, headerdata, parent=None):
        """
        Args:
            datain: a list of lists\n
            headerdata: a list of strings
        """
        QAbstractTableModel.__init__(self, parent)
        self.arraydata = datain
        self.headerdata = headerdata

    def rowCount(self, parent):
        return len(self.arraydata)

    def columnCount(self, parent):
        if len(self.arraydata) > 0: 
            return len(self.arraydata[0]) 
        return 0

    def data(self, index, role):
        if not index.isValid():
            return QVariant()
        elif role != Qt.DisplayRole:
            return QVariant()
        return QVariant(self.arraydata[index.row()][index.column()])

    def setData(self, index, value, role):
        pass         # not sure what to put here

    def headerData(self, col, orientation, role):
        if orientation == Qt.Horizontal and role == Qt.DisplayRole:
            return QVariant(self.headerdata[col])
        return QVariant()

    def sort(self, Ncol, order):
        """
        Sort table by given column number.
        """
        self.emit(SIGNAL("layoutAboutToBeChanged()"))
        self.arraydata = sorted(self.arraydata, key=operator.itemgetter(Ncol))       
        if order == Qt.DescendingOrder:
            self.arraydata.reverse()
        self.emit(SIGNAL("layoutChanged()"))

def main():
    app = QtWidgets.QApplication(sys.argv)  # Новый экземпляр QApplication
    window = myapp()  # Создаём объект класса myapp
    window.show()  # Показываем окно
    app.exec_()  # и запускаем приложение

if __name__ == '__main__':  # Если мы запускаем файл напрямую, а не импортируем
    main()  # то запускаем функцию main()

