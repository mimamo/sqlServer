USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBankHolidays_All]    Script Date: 12/21/2015 16:13:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBankHolidays_All] @parm1beg smalldatetime, @parm1end smalldatetime as
  Select * from XDDBankHolidays where
  Holiday Between @parm1beg and @parm1end
  Order by Holiday
GO
