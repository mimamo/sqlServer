USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSetup_Decplprccst]    Script Date: 12/21/2015 13:35:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSetup_Decplprccst] AS
select Decplprccst from EDSetup
GO
