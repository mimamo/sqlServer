USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[TrslHd_Status]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.TrslHd_Status    Script Date: 4/7/98 12:45:04 PM ******/
Create Proc [dbo].[TrslHd_Status] AS
     Select * from FSTrslHd
     Where Status IN ('I', 'S', 'B')
     Order by RefNbr, Status
GO
