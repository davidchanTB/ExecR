-------------------------------------------
-- Teradata R SQL call                   --
-- Return 4 rows after the ExecR is done --
-------------------------------------------
SELECT *
FROM TD_SYSGPL.ExecR (
on (
select rank() over( order by calendar_date ) as col1, col1 *10 as col2
from sys_calendar.calendar 
where calendar_date between current_date and current_date+3
)
hash by col1
local order by col2
using contract('library(tdr);
stream<-0;
direction<-"R";
incols<-tdr.GetColDef(stream, direction);
tdr.SetOutputColDef(stream,incols)')
operator('library(tdr);
stream<-0;
direction<-"R";
direction1<-"W";
options<-0;
inHandle<-tdr.Open(direction, stream, options);
print(inHandle);
outHandle<-tdr.Open(direction1, stream, options);
print(outHandle);
colcount <- tdr.GetColCount(stream , direction);
colcount <- colcount -1 ;
while(tdr.Read(inHandle)== 0)
{
for( index in 0:colcount )
{
att <- tdr.GetAttributeByNdx( inHandle , index , NULL);
tdr.SetAttributeByNdx(outHandle , index , att, NULL);
};
tdr.Write(outHandle);
};
tdr.Close(inHandle);
tdr.Close(outHandle);')
) as d1;

