USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_Star]    Script Date: 12/21/2015 16:00:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainerDet_Star] As
Select * From EDContainerDet
GO
