USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQAcctLoad]    Script Date: 12/21/2015 16:07:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQAcctLoad    Script Date: 9/1/00 9:39:16 AM ******/
CREATE PROCEDURE [dbo].[RQAcctLoad] @parm1 varchar(10), @parm2 varchar(10)  AS

select * from Account where active <> 0
and acct >= @parm1
and acct <= @parm2
order by acct
GO
