USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDItemAttribs_GetAttribs]    Script Date: 12/21/2015 14:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDItemAttribs_GetAttribs] @InvtId varchar(30) As
Select Attrib00, Attrib01, Attrib02, Attrib03, Attrib04, Attrib05, Attrib06, Attrib07,
Attrib08, Attrib09 From ItemAttribs Where InvtId = @InvtId
GO
