USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_Handling]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc  [dbo].[EDDataElement_Handling] @parm1 VARCHAR(15)  AS Select  * from EDDataElement where segment = 'ITA' and position = '04' and code like @parm1 order by segment, position, code
GO
