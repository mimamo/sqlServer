USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APHist_Delete]    Script Date: 12/21/2015 15:49:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APHist_Delete    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APHist_Delete] @parm1 varchar ( 255) as
Delete from APHist where APHist.Vendid = @parm1
GO
