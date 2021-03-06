USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xaccsub_Update]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xaccsub_Update] @global smallint, @table sysname, @curacct sysname, @cursub sysname as
set nocount on
DECLARE   @execstr varchar(2000)
if @global = 0
	set @execstr = ' declare @numrecs int select @numrecs = count(*) from '+@Table +',xaccsub where  '+@curacct + ' = xaccsub.xfromacct and '+@cursub + '= xaccsub.xfromsub select @numrecs 
	 if @numrecs > 0  Update '+@table + ' set '+@curacct  + ' =  xaccsub.xtoacct, ' + @cursub + '= xaccsub.xtosub from '+ @table + ', xaccsub where   '
	+@curacct + ' =  xaccsub.xfromacct and '+ @cursub + ' = xaccsub.xfromsub'

else
	set @execstr = ' declare @numrecs int select @numrecs = count(*) from '+@Table +',xaccsub where  global = 1 and '+@curacct + ' = xaccsub.xfromacct and '+@cursub + '= xaccsub.xfromsub  select @numrecs 
	 if @numrecs > 0  Update '+@table + ' set '+@curacct  + ' =  xaccsub.xtoacct, ' + @cursub + '= xaccsub.xtosub from '+ @table + ', xaccsub where  global = 1 and '
	+@curacct + ' =  xaccsub.xfromacct and '+ @cursub + ' = xaccsub.xfromsub'
exec(@execstr)
set nocount off
GO
