# Задача
Были исследованы M хромосом, каждая имеет свой номер от 1 до M. При этом обнаружены N *структурных вариаций* (далее СВ),
каждая из которых обнаружена только на некотором множестве хромосом с индексами в интервале {L_i;R_i}.

Даны условия, при которых хромосома из исследуемого набора считается *хорошей*. Из них K условий имеют вид 
"на хромосоме встречается либо вариация a_k, либо вариация b_k" и L условий имеют вид "на хромосоме не встречаются
одновременно вариации a_l и b_l".

Найти хотя бы одну хорошую хромосому (или указать, что таких нет).
# Идея
Можно решить задачу за O(M + N + K + L) как по времени, так и по памяти.
1. Составить структуру данных (словарь), где ключом будет индекс СВ, значением - список условий, на истинность которых
может влиять наличие или отсутствие этого СВ.
1. На первой хромосоме вычислить, какие СВ на ней есть и какие нет, запомнить это значение в массиве булевых значений.
1. Вычислить истинность всех K+L условий для первой хромосомы (сложность K + L + N). Запоминаем число истинных.
1. Пройтись по M хромосомам. Если в какой-то хромосоме у нас начало или конец интервала, содержащего СВ, в этом месте
меняем значение в булевом массиве и, пользуясь словарём, полученным на первом шаге, находим значения условий, которые
надо пересчитать -> пересчитываем. Если после этого оказалось, что число истинных условий равно числу всех условий, 
выходим из цикла - мы нашли ответ. Понятно, что каждое условие надо пересчитывать не более четырёх раз (т. к. оно 
зависит от двух значений СВ, каждое из которых меняется не более двух раз), поэтому временная сложность пересчёта O(K+L).
Временная сложность проверок и изменений значений в булевом массиве - O(N), поэтому снова сложность O(K + L + N).

# Реализация
Алгоритм в файле [sv-search.py](https://github.com/zuevval/source/blob/master/python/stu_labs/semester7/sv_search.py)
1. Составляем словарь:
    ```python
    sv_affects_conditions: DefaultDict[int, Set[int]] = defaultdict(set)
    for cond_idx, cond in enumerate(conditions):
        for sv_idx in [cond.a_idx, cond.b_idx]:
            sv_affects_conditions[sv_idx].add(cond_idx)
    ```
   Также создаём два словаря, в которых будем хранить соответствие индекса хромосомы и начинающихся/кончающихся на этом
   индексе интервалов СВ (это для того, чтобы можно было потом узнать по индексу хромосомы за O(1), какие СВ на ней
   начинаются и заканчиваются):
   ```python
    sv_starts: DefaultDict[int, List[int]] = defaultdict(list)
    sv_stops: DefaultDict[int, List[int]] = defaultdict(list)
    for sv_idx, sv_interval in enumerate(sv_bounds):
        sv_starts[sv_interval[0]].append(sv_idx)
        sv_stops[sv_interval[1] + 1].append(sv_idx)
    ```
1. Создаём массив булевых переменных, который будет меняться при итерировании по M хромосомам:
    ```python
    sv_truth_list = [True if idx in sv_starts[0] else False for idx in range(n_svs)]
    ```
1. Вычисляем истинность условий для первой (точнее, нулевой) хромосомы
    ```python
    true_conditions = [c.is_true(sv_truth_list) for c in conditions]
    n_true_conditions = sum(true_conditions)
    if n_true_conditions == n_conditions:
       return 0  # chromosome 0 is a possible answer
    ```
1. В цикле по всем хромосомам пересчитываем СВ (и затем пересчитываем условия, истинность которых при этом может поменяться)
    ```python
    for chr_idx in range(1, n_chromosomes):
        for sv_start_idx in sv_starts[chr_idx]:
            sv_truth_list[sv_start_idx] = True
        for sv_stop_idx in sv_stops[chr_idx]:
            sv_truth_list[sv_stop_idx] = False
        recalc_cond_ids = set()
        for sv_idx in [*sv_starts[chr_idx], *sv_stops[chr_idx]]:
            recalc_cond_ids = recalc_cond_ids.union(sv_affects_conditions[sv_idx])
        for cond_idx in recalc_cond_ids:
            new_cond_value = conditions[cond_idx].is_true(sv_truth_list)
            if new_cond_value is True and not true_conditions[cond_idx]:
                n_true_conditions += 1
            if new_cond_value is False and true_conditions[cond_idx]:
                n_true_conditions -= 1
            true_conditions[cond_idx] = new_cond_value
        if n_true_conditions == n_conditions:
            return chr_idx
    ```
1. Если закончили цикл, но так и не нашли хромосому, на которой число истинных условий не равно общему числу условий,
ответ не существует.
    ```python
    return -1
    ``` 
**Замечание.** Временную сложность последнего цикла в теории можно легко уменьшить с O(K + L + M + N) до O(K + L + M),
если при инициализации словарей `sv_starts` и `sv_stops` включать только те СВ, которые на что-то влияют:
```python
used_svs: Set[int] = set() # init a set of SVs which affect some conditions
for cond_idx, cond in enumerate(conditions):
    for sv_idx in [cond.a_idx, cond.b_idx]:
        sv_affects_conditions[sv_idx].add(cond_idx)
        used_svs.add(sv_idx) # add this SV to our set
sv_starts: DefaultDict[int, List[int]] = defaultdict(list)
sv_stops: DefaultDict[int, List[int]] = defaultdict(list)
for sv_idx, sv_interval in enumerate(sv_bounds):
    if sv_idx not in used_svs: # filter SVs
        break
    sv_starts[sv_interval[0]].append(sv_idx)
    sv_stops[sv_interval[1] + 1].append(sv_idx)
```
Впрочем, это несколько загромождает код, притом вряд ли даёт существенный выигрыш.