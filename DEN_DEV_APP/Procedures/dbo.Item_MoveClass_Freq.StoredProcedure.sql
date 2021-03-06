USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Item_MoveClass_Freq]    Script Date: 12/21/2015 14:06:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Item_MoveClass_Freq]
	@Siteid  Varchar(10),
        @MoveClass Varchar(10),
        @Freq_CountDate SmallDateTime

as

Update itemsite set selected = 1, countstatus = 'P'
    Where siteid = @Siteid
      And MoveClass = @MoveClass
      And LastCountDate <= @Freq_CountDate
      And CountStatus = 'A'
GO
