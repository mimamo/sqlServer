USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Location_ABCCode_Freq]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Location_ABCCode_Freq]
	@Siteid  Varchar(10),
        @ABCCode Varchar(2),
        @Freq_CountDate SmallDateTime

as

Update Loctable set selected = 1, countstatus = 'P'
    Where siteid = @Siteid
      And ABCCode = @ABCCode
      And LastCountDate <= @Freq_CountDate
      And CountStatus = 'A'
GO
