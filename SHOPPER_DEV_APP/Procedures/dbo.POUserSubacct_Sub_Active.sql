USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POUserSubacct_Sub_Active]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POUserSubacct_Sub_Active    Script Date: 12/17/97 10:49:12 AM ******/
Create Procedure [dbo].[POUserSubacct_Sub_Active] @parm1 Varchar(47), @parm2 Varchar(24) as
Select * from POUserSubacct  where
UserId = @parm1 and
Sub LIKE @parm2
order by UserId,Sub
GO
