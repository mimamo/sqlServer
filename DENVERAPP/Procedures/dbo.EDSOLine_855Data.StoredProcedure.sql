USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOLine_855Data]    Script Date: 12/21/2015 15:42:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOLine_855Data] @CpnyId varchar(10), @OrdNbr varchar(15) As
Select Count(*), Sum(QtyOrd), Max(PromDate) From SOLine Where CpnyId = @CpnyId And OrdNbr = @OrdNbr
GO
