USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BUGroup_YrVers]    Script Date: 12/21/2015 13:56:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BUGroup_YrVers    Script Date: 4/7/98 12:38:58 PM ******/
CREATE PROCEDURE [dbo].[BUGroup_YrVers]
@Parm1 varchar ( 10), @Parm2 varchar ( 4), @Parm3 varchar ( 10), @Parm4 varchar ( 24) AS
SELECT * FROM Budget_Group WHERE CpnyId = @Parm1 And budgetyear = @Parm2 And budgetledgerid = @Parm3 And bdgtsegment Like @Parm4 ORDER BY budgetyear, budgetledgerid, bdgtsegment, GroupId
GO
