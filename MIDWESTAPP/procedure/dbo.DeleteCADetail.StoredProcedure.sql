USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCADetail]    Script Date: 12/21/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeleteCADetail    Script Date: 4/7/98 12:49:20 PM ******/
Create Procedure [dbo].[DeleteCADetail] @parm1 varchar ( 10) As
Delete from Catran Where
CaTran.Batnbr = @parm1
GO
