USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[vp_08400ARDocAdjust_Sub_1]    Script Date: 12/21/2015 13:35:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_08400ARDocAdjust_Sub_1] AS
   
   SELECT CustId, AdjdDocType, AdjdRefNbr, PerAppl= Max(PerAppl) 
   FROM ARAdjust 
   WHERE S4Future11 = ' ' AND
         AdjgDocType NOT IN('NS','RP') 
   GROUP BY CustId, AdjdDocType, AdjdRefNbr
GO
