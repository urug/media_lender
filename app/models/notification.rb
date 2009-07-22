class Notification < ActionMailer::Base
  
  def invitation(user, to_email, sent_at = Time.now)
    subject    "You have been invited to view #{user.first_name}'s movies"
    recipients to_email
    from       'urug@solidcoresolutions.com'
    body       :user => user
    sent_on    sent_at
  end
  
  def borrow_notice_to_owner(borrower, movie, sent_at = Time.now)
    subject    "#{borrower.full_name} has requested to borrow #{movie.title}"
    recipients movie.user.email
    from       'urug@solidcoresolutions.com'
    body       :borrower => borrower, :movie => movie
    sent_on    sent_at
  end

end
