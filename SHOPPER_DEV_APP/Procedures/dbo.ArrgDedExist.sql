USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ArrgDedExist]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ArrgDedExist] @parm1 varchar (4) as
       Select max(ArrgDedAllow) from Deduction
            where CalYr = @parm1
GO
