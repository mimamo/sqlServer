USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ArrgDedExist]    Script Date: 12/21/2015 16:13:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ArrgDedExist] @parm1 varchar (4) as
       Select max(ArrgDedAllow) from Deduction
            where CalYr = @parm1
GO
