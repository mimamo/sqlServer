USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SISubacct_Pv]    Script Date: 12/21/2015 13:57:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SISubacct_Pv    Script Date: 4/7/98 12:42:26 PM ******/
/****** Object:  Stored Procedure dbo.SISubacct_Pv    Script Date: 12/17/97 10:48:54 AM ******/
Create Procedure [dbo].[SISubacct_Pv]  @Parm1 Varchar(25), @Parm2 Varchar(24) as
Select * from SubAcct where sub Like @Parm1 and sub Like @Parm2 and
Active = 1 Order by Sub
GO
