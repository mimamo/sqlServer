USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_Agency]    Script Date: 12/21/2015 16:00:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDDataElement_Agency] @parm1 varchar(15)  AS Select  * from EDDataElement where segment = 'ITA' and position = '02' and code like @parm1 order by segment, position, code
GO
