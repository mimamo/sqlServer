USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcCAS_Frl_Acct_Code]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcCAS_Frl_Acct_Code]  @entity_num smallint, @acct varchar( 10), @Sub varchar(24),@cpnyid varchar(10) as
declare @numrecs int
select @numrecs = count(*) from frl_acct_code where 
entity_num = @entity_num and acct = @acct and sub =  @sub and cpnyid = @cpnyid
if @numrecs > 0  
	BEGIN
		delete from frl_acct_code where
		entity_num = @entity_num and acct = @acct and sub =  @sub and cpnyid = @cpnyid
	END
GO
