USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcApv_Update]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcApv_Update] as
delete from xkcApv
insert  xkcApv (acct) select acct from account
GO
