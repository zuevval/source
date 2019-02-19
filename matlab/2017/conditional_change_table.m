M=1;
save('conditionals_table.m', 'M');
size(T);

Cell1 = {'89508022267'; '89117922761'; '89218618623'; '89218821061'; '89213365528'};
Cell2 = {'89522325549'; '0'; '89214216700'; '89643378624'; '89117911771'};
Cell3 = {'89991211214'; '89216357168'; '89995259840'; '89112375404'; '89621850833'};
Cell4 = {'89963240987'; '89533612749'; '89313488719'; '89213598882'; '89126853343'};
Cell5 = {'89043762060'; '89312071014'; '89817742908'; '89822147425'; '89210591705'};
Mail1 = {'none';'nikitaartamonov@mail.ru';'paskudaalisa@mail.ru';'belkovskaya.a@mail.ru';'mikk2000@mail.ru'};
Mail2 = {'zodiacstrelec2@mail.ru';'none';'dmitrievvlad1999@mail.ru';'valera.zuev.zva@gmail.com';'mashaivvas@gmail.com'};
Mail3 = {'klw.alexey@yandex.ru';'kozlovav.v1@gmail.com';'none';'akudakova@icloud.com';'pkipoon@yandex.ru'};
Mail4 = {'mosyagin.grisha@gmail.com';'viktoriya.mo4alina@yandex.ru';'mariiasamuylova99@yandex.ru';'semanov@inbox.ru';'gagarinkata@gmail.com'};
Mail5 = {'n.sokolova99@yandex.ru';'uya1999@yandex.ru';'aleksandr_fedorov_98@mail.ru';'none';'sherstneva.m5@mail.ru'};
Document1 = {'17360019'; '17360025'; '17360031'; '17360032'; '17360039'};
Document2 = {'17360041'; '17360175'; '17360054'; '17360064'; '17360180'};
Document3 = {'17360071'; '17360074'; '17360076'; '17360083'; '17360187'};
Document4 = {'17360102'; '17360104'; '17360131'; '17360133'; '17360138'};
Document5 = {'17360142'; '17360152'; '17360153'; '17360200'; '17360162'};
RowNames1 = {'Abramova'; 'Artamonov'; 'Begun'; 'Belkovskaya'; 'Velikov'};
RowNames2 = {'Voevodkina'; 'Gluhov'; 'Dmitriev'; 'Zuev'; 'Ivanova'};
RowNames3 = {'Klopov'; 'Kozlova'; 'Komarov'; 'Kudakova'; 'Lashkova'};
RowNames4 = {'Mosyagin'; 'Mochalina'; 'Samuilova'; 'Semanov'; 'Slovesny'};
RowNames5 = {'Sokolova'; 'Umnov'; 'Feodorov'; 'Tsis'; 'Sherstnova'};
RowNames = [RowNames1; RowNames2; RowNames3; RowNames4; RowNames5]
Cell = [Cell1; Cell2; Cell3; Cell4; Cell5]
Mail = [Mail1; Mail2; Mail3; Mail4; Mail5];
Document = [Document1; Document2; Document3; Document4; Document5];
T = table(Cell, Document, Mail, 'RowNames', RowNames)
save('conditionals_table.m', 'T');
