USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BUGroup_YrVersSel]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BUGroup_YrVersSel    Script Date: 4/7/98 12:38:58 PM ******/
CREATE PROCEDURE [dbo].[BUGroup_YrVersSel]
@Parm1 varchar ( 4), @Parm2 varchar ( 10), @Parm3 varchar ( 24) AS
SELECT * FROM Budget_Group WHERE budgetyear = @Parm1 And budgetledgerid = @Parm2 And bdgtsegment LIKE @Parm3 ORDER BY budgetyear, budgetledgerid, bdgtsegment
GO
