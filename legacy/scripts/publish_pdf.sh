#! /bin/bash

export JAVA_CMD="java"
export JAVA_FONTS="../transform/"
export JAVA_ARGS="-Djavax.xml.transform.TransformerFactory=net.sf.saxon.TransformerFactoryImpl"
export JAVA_CLASSPATH="/usr/share/java/Saxon-HE.jar"

CONFIG="../transform/fop.print.cfg"

SOURCE_XML="../core.xml"
SOURCE_XSL="../transform/print.xsl"

OUTPUT="../published/pdf/CORE_-_Cooperative_Open_Roleplaying_Engine.pdf"

fop -xml $SOURCE_XML -xsl $SOURCE_XSL -pdf $OUTPUT -c $CONFIG
