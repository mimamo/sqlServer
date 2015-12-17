USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xCpnyaccsub_Update]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xCpnyaccsub_Update] @global smallint, @table sysname, @curacct sysname, @cursub sysname, @cpnyid varchar(70) as
set nocount on
DECLARE   @execstr varchar(2000)
if @global = 0
	set @execstr = ' declare @numrecs int select @numrecs = count(*) from '+@Table +',xkccpnyacctsub where '
        +@cpnyid + 'and '+@curacct + ' = xkccpnyacctsub.xfromacct and '+@cursub + '= xkccpnyacctsub.xfromsub select @numrecs 
	 if @numrecs > 0  Update '+@table + ' set '+@curacct  + ' =  xkccpnyacctsub.xtoacct, ' + @cursub + '= xkccpnyacctsub.xtosub from '+ @table + ', 
	xkccpnyacctsub where '+@cpnyid + 'and '
	+@curacct + ' =  xkccpnyacctsub.xfromacct and '+ @cursub + ' = xkccpnyacctsub.xfromsub'

else
	set @execstr = ' declare @numrecs int select @numrecs = count(*) from '+@Table +',xkccpnyacctsub where  global = 1 and '
	+@cpnyid + 'and '+@curacct + ' = xkccpnyacctsub.xfromacct and '+@cursub + '= xkccpnyacctsub.xfromsub  select @numrecs 
	 if @numrecs > 0  Update '+@table + ' set '+@curacct  + ' =  xkccpnyacctsub.xtoacct, ' + @cursub + 
	'= xkccpnyacctsub.xtosub from '+ @table + ', xkccpnyacctsub where  global = 1 and '+@cpnyid + 'and '
	+ @curacct + ' =  xkccpnyacctsub.xfromacct and '+ @cursub + ' = xkccpnyacctsub.xfromsub'
exec(@execstr)
set nocount off
GO
