USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDiscCode_AllDMG]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDDiscCode_AllDMG] @SpecChgCode varchar(5) as
Select * From EDDiscCode Where SpecChgCode Like @SpecChgCode
GO
