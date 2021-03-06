USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDEdiDataElemV_Vendid_V_S]    Script Date: 12/21/2015 16:13:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDEdiDataElemV_Vendid_V_S] @parm1 varchar(15), @parm2 varchar(6), @parm3 varchar(3) AS
  Select * from XDDEdiDataElemV, XDDEdiDataElem where XDDEdiDataElemV.EdiVersion = XDDEdiDataElem.EdiVersion and
  XDDEdiDataElemV.DataElemRN = XDDEdiDataElem.DataElemRN and
  XDDEdiDataElemV.Vendid = @parm1 and
  XDDEdiDataElemV.EdiVersion = @parm2 and
  XDDEdiDataElemV.SegID = @parm3
  ORDER by XDDEdiDataElemV.SeqNbr
GO
