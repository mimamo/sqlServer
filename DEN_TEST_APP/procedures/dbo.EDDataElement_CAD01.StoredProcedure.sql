USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_CAD01]    Script Date: 12/21/2015 15:36:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDDataElement_CAD01] @parm1 varchar(15) AS
SELECT *
FROM EDDataElement
WHERE segment = 'CAD' and position = '01' and code like @parm1
ORDER BY segment, position, code
GO
