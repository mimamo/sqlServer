USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_BasisCode]    Script Date: 12/21/2015 15:36:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDDataElement_BasisCode] @parm1 varchar(15)  AS Select  * from EDDataElement where segment = 'ITD' and position = '02' and code like @parm1 order by segment, position, code
GO
