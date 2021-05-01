window.onload = init ;

function init() {
    replacePageBreaks() ;
    expandOverflow() ;
    setPageNumbering() ;
    setTOCPageNumbers() ;
}

function isOverflowing(e) {
    return e.scrollWidth > e.clientWidth ;
}

function expandOverflow() {
    do {
        var overflow = false ;
        var pages = document.querySelectorAll("div.page") ;
        for (i = 0 ; !overflow && i < pages.length ; ++i) {
            page = pages[i] ;
            if(isOverflowing(page)) {
                if(!page.nextSibling) {
                    newp = document.createElement("div") ;
                    newp.classList.add("page") ;
                    page.parentNode.appendChild(newp) ;
                    overflow = true ;
                }
                while(isOverflowing(page)) { page.nextSibling.insertBefore(page.lastChild,page.nextSibling.firstChild) ; }
            }
        }
    }
    while(overflow) ;
}

function replacePageBreaks() {
    body = document.getElementsByTagName("body")[0] ;
    body.innerHTML = body.innerHTML.replace(/<br>/g,"</div><div class=\"page\">") ;
}

function setPageNumbering() {
    pages = document.querySelectorAll("div.page") ;
    let n = 1 ;
    for(page of pages) {
        page.dataset["pagenumber"] = n++;
    }
}

function setTOCPageNumbers() {
    links = document.querySelectorAll("nav a") ;
    for(link of links) {
        ref = document.getElementById(link.href.split("#")[1]) ;
        if(ref.firstElementChild && ref.firstElementChild.tagName == "DIV" && ref.firstElementChild.classList.contains("page")) {
            ref = ref.firstElementChild.dataset["pagenumber"] ;
        }
        else {
            while(ref.parentNode && !(ref.parentNode.tagName == "DIV" && ref.parentNode.classList.contains("page"))) { ref = ref.parentNode ;}
            ref = ref.parentNode.dataset["pagenumber"] ;
        }
        link.dataset["pageref"] = ref ;
    }
}
