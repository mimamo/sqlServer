USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_Star]    Script Date: 12/21/2015 15:36:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainerDet_Star] As
Select * From EDContainerDet
GO
