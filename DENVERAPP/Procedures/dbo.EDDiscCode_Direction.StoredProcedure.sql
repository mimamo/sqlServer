USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDiscCode_Direction]    Script Date: 12/21/2015 15:42:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDDiscCode_Direction] @Direction varchar(1), @CustId varchar(15), @SpecChgCode varchar(5) As
Select * From EDDiscCode Where Direction = @Direction And CustId In (@CustId, '*') And
SpecChgCode Like @SpecChgCode Order By SpecChgCode
GO
