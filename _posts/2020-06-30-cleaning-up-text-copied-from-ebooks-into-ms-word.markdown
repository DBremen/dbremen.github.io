---
author: dirkbremen
comments: true
date: 2018-08-09 09:53:56+00:00
layout: post
link: https://powershellone.wordpress.com/2018/08/09/cleaning-up-text-copied-from-ebooks-into-ms-word/
slug: cleaning-up-text-copied-from-ebooks-into-ms-word
title: Cleaning up text copied from eBooks into MS Word
wordpress_id: 1209
categories:
- Word
---

![42763897005_59ee30b8c0](https://powershellone.files.wordpress.com/2018/08/42763897005_59ee30b8c0.jpg)

My preference for reading books is ebooks over printed books. One thing I like about eBooks is the ability to copy and paste chunks of text into Word documents, that I use to summarize the books for better retention. Often times the text contains arbitrary spaces inbetween words, hyphenation, and or word wraps after being pasted into word, though.:

![cleanupWordBefore](https://powershellone.files.wordpress.com/2018/08/cleanupwordbefore1.png)

In this post I would like to share a small Word Macro I use in order to "cleanup" text after it's being pasted into a Word document from an eBook. Running the macro should turn the example text into this:

![cleanupWordAfter](https://powershellone.files.wordpress.com/2018/08/cleanupwordafter.png).

The macro is just using the VBA built-in Find method in order to perform multiple successive [search and replace](https://bettersolutions.com/word/documents/vba-find-and-replace.htm) actions against a selected text.
utili



	
	
  1. Insert a marker at the end of the selected text "®®".


  2. Replace the paragraph mark "^p" with a space.

	
  3. Utilize a regular expression in order to replace multiple spaces between words with one.


  4. Remove hyphenation.

	
  5. Replace the end marker with a paragraph mark.

	
  6. Remove spaces that precede a period.

	
  7. Remove formatting by applying the "Normal" style to the selected text



You can follow the instructions from this [youtube video](https://www.youtube.com/watch?v=1HK_HrxUnKw) to add the macro to your global word template (normal.dotm) in order to make it available for all your Word document and those over [here](https://www.techrepublic.com/article/how-to-add-office-macros-to-the-qat-toolbar-for-quick-access/) to add a button to Word's quick access bar that launches the Macro.

Here is the code:
https://gist.github.com/DBremen/36d2816fff59537486dd1c292a707580

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *



Photo Credit: [hans-johnson](https://www.flickr.com/photos/69825860@N04/42763897005/) Flickr via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nd/2.0/)
