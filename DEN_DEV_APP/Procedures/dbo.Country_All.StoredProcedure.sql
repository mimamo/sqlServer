USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Country_All]    Script Date: 12/21/2015 14:05:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Country_All    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[Country_All] @parm1 varchar ( 3) as
    Select * from Country where CountryId like @parm1 order by CountryId
GO
