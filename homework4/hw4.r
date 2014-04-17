library(tm)
library(wordcloud)
library(ggplot2)

init = function () {
sotu_source <- DirSource(
    # indicate directory
    #directory = file.path("sotu"),
    encoding = "UTF-8",     # encoding
    pattern = "*.txt",      # filename pattern
    recursive = FALSE,      # visit subdirectories?
    ignore.case = FALSE)    # ignore case in pattern?

corp <- Corpus(
    sotu_source, 
    readerControl = list(
        reader = readPlain, # read as plain text
        language = "en"))   # language is english


corp <- tm_map(corp, removePunctuation)
corp <- tm_map(corp, removePunctuation)
corp <- tm_map(corp, tolower)
corp <- tm_map(corp, removeNumbers)
corp <- tm_map(corp, function(x)removeWords(x,stopwords()))

term.matrix <- TermDocumentMatrix(corp)
term.matrix <<- as.matrix(term.matrix)
}

Word = function() {
colnames(term.matrix) <- substr(colnames(term.matrix),1,4)
comparison.cloud(term.matrix,max.words=75,random.order=FALSE)
x11()
commonality.cloud(term.matrix,max.words=100,random.order=FALSE)
}

myFreq = function () {
   files=list.files(pattern="*.txt")
   returnType = c("paragraphs", "sentences", "words", "dollar.signs", "war", "peace", "debt", "economy")
   result  = array (dim=c(length(files), length(returnType)),           dimnames=list(substr(files,1,4), returnType))
   for (f in files) { 
      d=as.matrix(read.csv(f,header=F, as.is=T, sep=" ",strip.white=T))
      fs = substr(f,1,4)
      result[fs,"paragraphs"] = nrow(d)*1.0
      result[fs,"sentences"] = length(grep("\\.$",d,ignore.case=T))*1.0 
      result[fs,"words"] = length(d) - sum(d=="")*1.0
	  w = result[fs,"words"]
      result[fs,"dollar.signs"] = length(grep("\\$",d,ignore.case=T))*1000/w
      result[fs,"war"] = length(grep("war",d,ignore.case=T))*1000/w
      result[fs,"peace"] = length(grep("peace",d,ignore.case=T))*1000/w
      #result[fs,"debt"] = length(grep("debt",d,ignore.case=T))*1000/w
      #result[fs,"economy"] = length(grep("economy",d,ignore.case=T))*1000/w
   }
   df = data.frame(result)
   df$year = as.numeric(rownames(result))
   rownames(df)=NULL
   df
}

myFreq2 = function () {
   files=list.files(pattern="*.txt")
   returnType = c("words","dollar.signs", "war", "peace", "debt", "economy")
   result  = array (dim=c(length(files), length(returnType)),           dimnames=list(substr(files,1,4), returnType))
   for (f in files) { 
      d=as.matrix(read.csv(f,header=F, as.is=T, sep=" ",strip.white=T))
      fs = substr(f,1,4)
      result[fs,"words"] = length(d) - sum(d=="")*1.0
	  w = result[fs,"words"]
      result[fs,"dollar.signs"] = length(grep("\\$",d,ignore.case=T))*1000/w
      result[fs,"war"] = length(grep("war",d,ignore.case=T))*1000/w
      result[fs,"peace"] = length(grep("peace",d,ignore.case=T))*1000/w
      result[fs,"debt"] = length(grep("debt",d,ignore.case=T))*1000/w
      result[fs,"economy"] = length(grep("economy",d,ignore.case=T))*1000/w
   }
   df = data.frame(result)
   df$year = as.numeric(rownames(result))
   rownames(df)=NULL
   df
}
myFreq3 = function () {
   files=list.files(pattern="*.txt")
   returnType = c("words","and", "or", "paragraphs","comma","semicolon","sentences")
   result  = array (dim=c(length(files), length(returnType)),           dimnames=list(substr(files,1,4), returnType))
   for (f in files) { 
      d=as.matrix(read.csv(f,header=F, as.is=T, sep=" ",strip.white=T))
      fs = substr(f,1,4)
	  w = length(d) - sum(d=="")*1.0
      result[fs,"words"] = 1000/w
      result[fs,"sentences"] = length(grep("\\.$",d,ignore.case=T))*1000/w 
      result[fs,"paragraphs"] = nrow(d)*1000/w
      result[fs,"and"] = length(grep("and",d,ignore.case=T))*1000/w
      result[fs,"or"] = length(grep("or",d,ignore.case=T))*1000/w
      result[fs,"comma"] = length(grep(",",d,ignore.case=T))*1000/w
      result[fs,"semicolon"] = length(grep(";",d,ignore.case=T))*1000/w
   }
   df = data.frame(result)
   df$year = as.numeric(rownames(result))
   rownames(df)=NULL
   df
}

gP = function (df){
   p = ggplot(df, aes(year))
   p = p + geom_point(aes(y=comma,color="comma"))
   p = p + geom_smooth(aes(y=comma,color="comma"),se=F)
   p = p + geom_point(aes(y=sentences,color="sentence"))
   p = p + geom_smooth(aes(y=sentences,color="sentence"),se=F)
   p = p + geom_point(aes(y=and,color="and"))
   p = p + geom_smooth(aes(y=and,color="and"),se=F)
   p = p + geom_point(aes(y=or,color="or"))
   p = p + geom_smooth(aes(y=or,color="or"),se=F)
   p = p + geom_point(aes(y=paragraphs,color="paragraph"))
   p = p + geom_smooth(aes(y=paragraphs,color="paragraph"),se=F)
   p = p + geom_point(aes(y=semicolon,color="semicolon"))
   p = p + geom_smooth(aes(y=semicolon,color="semicolon"),se=F)
   p = p+ ggtitle("Presidential Grammar Analysis, via State of the Union Speeches")
   p = p+ labs(y="frequency, per 1000 words",color="grammar element")
   print(p)
}

init()
Word()
x11()
gP(myFreq3())
