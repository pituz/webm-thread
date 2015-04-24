##### Скрипты для репорта пидораторов в /d/ (вставлять в JS-консоль браузера):

Кол-во удалённых постов на странице:
```
alert($('.de-post-deleted').length)
```
Заполнить страницу постами (не работает):
```
$('.post').css('display','inline')
```
Вернуть:
```
$('.post').css('display','table')
```
Скрыть все посты кроме удалённых:
```
$('.post-wrapper').not('.de-post-removed').hide()
```
Вернуть:
```
$('.post-wrapper').show()
```
Отмечать красным посты по клику даты:
```
$('.posttime').click(function(event){$(this).parent().parent().parent().css('border-color','red')});
```

Требуется наличие куклоскрипта.
