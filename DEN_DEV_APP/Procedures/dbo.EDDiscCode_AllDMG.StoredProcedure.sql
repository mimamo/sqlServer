USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDiscCode_AllDMG]    Script Date: 12/21/2015 14:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDDiscCode_AllDMG] @SpecChgCode varchar(5) as
Select * From EDDiscCode Where SpecChgCode Like @SpecChgCode
GO
