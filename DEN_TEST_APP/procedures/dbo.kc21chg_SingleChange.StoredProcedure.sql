USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[kc21chg_SingleChange]    Script Date: 12/21/2015 15:36:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[kc21chg_SingleChange] @keyid  varchar (8) as
select * from kc21chg where 
keyid = @keyid 
and global < 1
and fromkey <> '' 
and tokey <> ''
order by keyid, gridorder
GO
