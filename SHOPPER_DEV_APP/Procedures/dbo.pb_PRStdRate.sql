USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pb_PRStdRate]    Script Date: 12/16/2015 15:55:25 ******/
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
