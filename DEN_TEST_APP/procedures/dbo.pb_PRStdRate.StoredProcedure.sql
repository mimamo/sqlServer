USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pb_PRStdRate]    Script Date: 12/21/2015 15:37:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pb_PRStdRate] @RI_ID SMALLINT
AS

    if exists (select DedId from Deduction where BaseType = 'S') OR
       exists (select Union_Cd from UnionDeduct where BaseType = 'S')
        UPDATE RptRunTime SET ShortAnswer04 = 'TRUE' WHERE RI_ID = @RI_ID
GO
