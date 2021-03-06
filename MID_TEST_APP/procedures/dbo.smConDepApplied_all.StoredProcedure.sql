USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConDepApplied_all]    Script Date: 12/21/2015 15:49:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConDepApplied_all] @parm1 varchar(10), @parm2 smallint, @parm3 int, @parm4 int AS
        SELECT *
          FROM smConDepApplied
         WHERE BatNbr      = @parm1
           AND LineNbr     = @parm2
           AND RecordID between @parm3 and @parm4
      ORDER BY BatNbr,
               LineNbr,
               RecordID
GO
