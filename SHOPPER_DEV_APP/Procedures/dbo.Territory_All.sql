USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Territory_All]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Territory_All    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[Territory_All] @parm1 varchar (10) as
    Select * from Territory where
    Territory like @parm1
    order by Territory
GO
