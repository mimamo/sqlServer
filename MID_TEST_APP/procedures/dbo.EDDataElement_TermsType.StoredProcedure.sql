USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_TermsType]    Script Date: 12/21/2015 15:49:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDDataElement_TermsType] @parm1 varchar(15)  AS Select  * from EDDataElement where segment = 'ITD' and position = '01' and code like @parm1 order by segment, position, code
GO
