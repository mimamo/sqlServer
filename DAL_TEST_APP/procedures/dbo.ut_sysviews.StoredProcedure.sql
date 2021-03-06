USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ut_sysviews]    Script Date: 12/21/2015 13:57:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ut_sysviews] (@db_name varchar(100) )
as
declare @tabname varchar(100)
declare @declstring varchar(255)
declare @newstring  varchar(250)

select @declstring=
'declare c1 cursor for select substring(name,1,100) from '+@db_name+'.dbo.sysobjects where type = ''u'' '
exec (@declstring)
open c1
fetch c1 into @tabname
while (@@FETCH_STATUS = 0)
begin
  If exists (select * from sysobjects where name = 'vs_'+ @tabname)
  begin
     select @newstring='drop view vs_' + @tabname
     exec (@newstring)
  end 
  select @newstring='create view vs_'+@tabname
    +' as select * from  '+ @db_name
    +'..' + @tabname
  exec (@newstring)
  fetch c1 into @tabname
end
close c1
deallocate c1
GO
