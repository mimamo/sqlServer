USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_1325_Curyacct]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_1325_Curyacct]  @cpnyid varchar(10), @acct varchar(10), @sub varchar(24), @ledgerid varchar(10), @fiscyr varchar(4), @curyid varchar(4) as
select * from Curyacct where 
cpnyid = @cpnyid
and acct = @acct
and sub = @sub
and ledgerid = @ledgerid
and fiscyr = @fiscyr
and curyid = @curyid
order by cpnyid
GO
