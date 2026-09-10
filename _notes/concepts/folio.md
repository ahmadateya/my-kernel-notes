# folio concept from the mm subsystem

physical memory is chucked as pages in the kernel (represented as `struct page`) 

## Compound pages

- lets say the kernel needs a big chunk of memory more than one page.
- then he combine multiple pages together and call it `compound page`
- they are still multiple pages and they will be grouped together in a list or array.
- first page in the list will hold ALL the needed info and the others will be just follower (similar to what do in C array: pointer to the first element)
    - this info are: the flags, _refcount, mapping, order...etc 
- first page called `head page`, and the others called `tail pages`

## folio
- الاسم جاي من اللاتيني بمعنى ورقة بتطوي اكتر من مرة فتعمل كذا صفحة
- page = صفحة, folio = الورقة اللي عليها الصفحات دي

- from the naming its an abstraction to hold the these (grouped) pages together (compound page)

### the problem it solves
because compound page are some pages together in a list and only the first page have the needed info, if you asked these `tail pages` about mapping or whatever you will get wrong answers so you will must get the `head page` every time you deal with one of these tail pages (repeated work)  


## Resources
- http://lwn.net/Articles/1064861/
- https://lwn.net/Articles/1073425/