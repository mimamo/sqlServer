USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQEAAcctMat_DBNav]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQEAAcctMat_DBNav    Script Date: 9/4/2003 6:21:19 PM ******/

/****** Object:  Stored Procedure dbo.RQEAAcctMat_DBNav    Script Date: 7/5/2002 2:44:39 PM ******/

/****** Object:  Stored Procedure dbo.RQEAAcctMat_DBNav    Script Date: 1/7/2002 12:23:10 PM ******/

/****** Object:  Stored Procedure dbo.RQEAAcctMat_DBNav    Script Date: 1/2/01 9:39:35 AM ******/

/****** Object:  Stored Procedure dbo.RQEAAcctMat_DBNav    Script Date: 11/17/00 11:54:29 AM ******/
CREATE PROCEDURE [dbo].[RQEAAcctMat_DBNav] @parm1 varchar(10)
 AS
Select * from EAAcctMat where
Account like @parm1
Order by Account, MaterialType
GO
