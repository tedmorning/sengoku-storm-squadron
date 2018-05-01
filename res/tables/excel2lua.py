import os
import sys
import codecs
import xlrd #http://pypi.python.org/pypi/xlrd

if len(sys.argv) != 1 :
    print "argv count != 1, program exit"
    exit(0)

def FloatToString (aFloat):
    if type(aFloat) != float:
        return ""
    strTemp = str(aFloat)
    strList = strTemp.split(".")
    if len(strList) == 1 :
        return strTemp
    else:
        if strList[1] == "0" :
            return strList[0]
        else:
            return strTemp

targetFile = codecs.open("data2.lua","w","utf-8")

data = xlrd.open_workbook(u"enemy.xlsx")
indexTable = data.sheet_by_name(u"index")
rs = indexTable.nrows
targetFile.write(u"enemy" + u" = {}\n\n")
for r in range(rs-1):
    tablename = indexTable.cell_value(r+1,0)
    table = data.sheet_by_name(tablename)
    nrows = table.nrows
    ncols = table.ncols
    targetFile.write(u"enemy." + tablename + u" = {\n")
    for r in range(nrows-1):
        for c in range(ncols):
            if c == 0:
                targetFile.write(u"\t[" + FloatToString(table.cell_value(r+1,c)) + u"] = " + u"{ ")
            else:
                strCellValue = u""
                CellObj = table.cell_value(r+1,c)
                if type(CellObj) == unicode:
                    strCellValue = u"\"" + CellObj + u"\""
                elif type(CellObj) == float:
                    strCellValue = FloatToString(CellObj)
                else:
                    strCellValue = "nil"
                strTmp = table.cell_value(0,c) + u" = "+ strCellValue
                if c< ncols-1:
                    strTmp += u", "
                targetFile.write(strTmp)
        targetFile.write(u" }")
        if r < nrows-2:
            targetFile.write(u",")
        targetFile.write(u"\n")
    targetFile.write(u"}\n\n")

data = xlrd.open_workbook(u"level.xlsx")
indexTable = data.sheet_by_name(u"index")
targetFile.write(u"level" + u" = {}\n\n")
rs = indexTable.nrows
for r in range(rs-1):
    tablename = indexTable.cell_value(r+1,0)
    table = data.sheet_by_name(tablename)
    nrows = table.nrows
    ncols = table.ncols
    targetFile.write(u"level." + tablename + u" = {\n")
    for r in range(nrows-1):
        for c in range(ncols):
            if c == 0:
                targetFile.write(u"\t[" + FloatToString(table.cell_value(r+1,c)) + u"] = " + u"{ ")
            else:
                strCellValue = u""
                CellObj = table.cell_value(r+1,c)
                if type(CellObj) == unicode:
                    strCellValue = u"\"" + CellObj + u"\""
                elif type(CellObj) == float:
                    strCellValue = FloatToString(CellObj)
                else:
                    strCellValue = "nil"
                strTmp = table.cell_value(0,c) + u" = "+ strCellValue
                if c< ncols-1:
                    strTmp += u", "
                targetFile.write(strTmp)
        targetFile.write(u" }")
        if r < nrows-2:
            targetFile.write(u",")
        targetFile.write(u"\n")
    targetFile.write(u"}\n\n")

data = xlrd.open_workbook(u"player.xlsx")
indexTable = data.sheet_by_name(u"index")
targetFile.write(u"player" + u" = {}\n\n")
rs = indexTable.nrows
for r in range(rs-1):
    tablename = indexTable.cell_value(r+1,0)
    table = data.sheet_by_name(tablename)
    nrows = table.nrows
    ncols = table.ncols
    targetFile.write(u"player." + tablename + u" = {\n")
    for r in range(nrows-1):
        for c in range(ncols):
            if c == 0:
                targetFile.write(u"\t[" + FloatToString(table.cell_value(r+1,c)) + u"] = " + u"{ ")
            else:
                strCellValue = u""
                CellObj = table.cell_value(r+1,c)
                if type(CellObj) == unicode:
                    strCellValue = u"\"" + CellObj + u"\""
                elif type(CellObj) == float:
                    strCellValue = FloatToString(CellObj)
                else:
                    strCellValue = "nil"
                strTmp = table.cell_value(0,c) + u" = "+ strCellValue
                if c< ncols-1:
                    strTmp += u", "
                targetFile.write(strTmp)
        targetFile.write(u" }")
        if r < nrows-2:
            targetFile.write(u",")
        targetFile.write(u"\n")
    targetFile.write(u"}\n\n")
    
data = xlrd.open_workbook(u"ui.xlsx")
indexTable = data.sheet_by_name(u"index")
rs = indexTable.nrows
targetFile.write(u"ui" + u" = {}\n\n")
for r in range(rs-1):
    tablename = indexTable.cell_value(r+1,0)
    table = data.sheet_by_name(tablename)
    nrows = table.nrows
    ncols = table.ncols
    targetFile.write(u"ui." + tablename + u" = {\n")
    for r in range(nrows-1):
        for c in range(ncols):
            if c == 0:
                targetFile.write(u"\t[" + FloatToString(table.cell_value(r+1,c)) + u"] = " + u"{ ")
            else:
                strCellValue = u""
                CellObj = table.cell_value(r+1,c)
                if type(CellObj) == unicode:
                    strCellValue = u"\"" + CellObj + u"\""
                elif type(CellObj) == float:
                    strCellValue = FloatToString(CellObj)
                else:
                    strCellValue = "nil"
                strTmp = table.cell_value(0,c) + u" = "+ strCellValue
                if c< ncols-1:
                    strTmp += u", "
                targetFile.write(strTmp)
        targetFile.write(u" }")
        if r < nrows-2:
            targetFile.write(u",")
        targetFile.write(u"\n")
    targetFile.write(u"}\n\n")    
    
data = xlrd.open_workbook(u"endlessLevel.xlsx")
indexTable = data.sheet_by_name(u"index")
targetFile.write(u"endlessLevel" + u" = {}\n\n")
rs = indexTable.nrows
for r in range(rs-1):
    tablename = indexTable.cell_value(r+1,0)
    table = data.sheet_by_name(tablename)
    nrows = table.nrows
    ncols = table.ncols
    targetFile.write(u"endlessLevel." + tablename + u" = {\n")
    for r in range(nrows-1):
        for c in range(ncols):
            if c == 0:
                targetFile.write(u"\t[" + FloatToString(table.cell_value(r+1,c)) + u"] = " + u"{ ")
            else:
                strCellValue = u""
                CellObj = table.cell_value(r+1,c)
                if type(CellObj) == unicode:
                    strCellValue = u"\"" + CellObj + u"\""
                elif type(CellObj) == float:
                    strCellValue = FloatToString(CellObj)
                else:
                    strCellValue = "nil"
                strTmp = table.cell_value(0,c) + u" = "+ strCellValue
                if c< ncols-1:
                    strTmp += u", "
                targetFile.write(strTmp)
        targetFile.write(u" }")
        if r < nrows-2:
            targetFile.write(u",")
        targetFile.write(u"\n")
    targetFile.write(u"}\n\n")
    
targetFile.close()