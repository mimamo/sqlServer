USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Terms_All]    Script Date: 12/21/2015 14:06:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Terms_All    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[Terms_All] @parm1 varchar ( 2) as
    Select * from Terms where TermsId like @parm1 order by TermsId
GO
