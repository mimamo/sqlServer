USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Terms_Descr]    Script Date: 12/21/2015 15:43:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Terms_Descr    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[Terms_Descr] @parm1 varchar (2) As
     Select Descr from Terms
     Where TermsID = @parm1
GO
