USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_AllOnTare]    Script Date: 12/21/2015 13:57:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainer_AllOnTare] @TareId varchar(10) As
Select * From EDContainer Where TareId = @TareId
GO
