USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[RptCompany_Insert]    Script Date: 12/21/2015 13:45:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[RptCompany_Insert] @parm1 smallint, @parm2 varchar (10), @parm3 varchar (30) as
INSERT INTO RptCompany (RI_ID, CpnyID, CpnyName, tstamp)
VALUES (@parm1, @parm2, @parm3, NULL)
GO
